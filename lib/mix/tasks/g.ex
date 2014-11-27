defmodule Mix.Tasks.Potion do
  defmodule G do
    
    use Mix.Task
    import Mix.Generator
    import Mix.Utils, only: [camelize: 1, underscore: 1]

    @shortdoc "For model code generation"

    @moduledoc """
      A task for generating model struct, its database migration and Repo if it does not exist yet
    """

    def run(["model" | [model_name | attributes]]) do
      app_name = Mix.Project.config[:app]
      project_module_name = camelize(to_string(Mix.Project.config[:app]))
      attributes_table_map = attributes_table_from_attributes_array(attributes)
      repo_module = Module.concat([project_module_name, "Repo"]) 

      generate_repo_file(app_name, repo_module)
      generate_model_file(model_name, project_module_name, Map.get(attributes_table_map, :for_model_file, []))
      generate_migration_file(model_name, project_module_name, Map.get(attributes_table_map, :for_migration_file, []))
    end

    def run(_) do
      IO.puts "Incorrect syntax. Please try mix potion.g model <model_name> [attribute1] [attribute2]..."
    end

    def attributes_table_from_attributes_array(attributes) do
      Enum.reduce(attributes, %{}, fn(attribute, dict) ->
        if String.contains?(attribute, ":") do
          [attribute_name, attribute_type] = String.split(attribute, ":")
        else # if not specify attribute type, it will be deemed as string
          [attribute_name, attribute_type] = [attribute, "string"]
        end

        model_attributes_table = Map.get(dict, :for_model_file, [])
        model_attributes_table = model_attributes_table \
            ++ ["field :#{attribute_name}, :#{ecto_attribute_type_map(attribute_type)}"]
        dict = Map.put(dict, :for_model_file, model_attributes_table)

        migration_attributes_table = Map.get(dict, :for_migration_file, [])
        migration_attributes_table = migration_attributes_table \
            ++ ["#{attribute_name} #{postgres_attribute_type_map(attribute_type)}"]
        dict = Map.put(dict, :for_migration_file, migration_attributes_table)
      end)
    end

    def postgres_attribute_type_map(attribute_type) do
      case attribute_type do
        "float" -> "real"
        "string" -> "varchar(255)"
        "decimal" -> "decimal(10, 4)"
        "datetime" -> "timestamp"
        other -> other 
      end
    end

    def ecto_attribute_type_map(attribute_type) do
      case attribute_type do
        "text" -> "string"
        other -> other 
      end
    end

    defp generate_repo_file(app_name, repo_module) do
      repo_path = Path.join(System.cwd(), "web/models/repo.ex")
      if File.exists?(repo_path) == false do
        create_file repo_path, repo_template(
          repo_module: repo_module,
          app_name: app_name
        )
      end
    end

    defp generate_model_file(model_name, project_module_name, attributes_map) do
      model_destination = Path.join(System.cwd(), "/web/models/#{underscore(model_name)}.ex")
      create_file model_destination, model_template(
          model_name: Module.concat(project_module_name, camelize(model_name)),
          table_name: Inflex.pluralize(underscore(model_name)),
          attributes_table: Enum.join(attributes_map, "\n\t\t") 
      ) 
    end

    defp generate_migration_file(model_name, repo_module, table_fields) do
      path = Path.join(System.cwd(), "/priv/repo/migrations")
      migration_file = Path.join(path, "#{timestamp}_create_#{underscore(model_name)}.exs")
      table_name = Inflex.pluralize(underscore(model_name))

      create_file migration_file, migration_template(
        mod: Module.concat([repo_module, Migrations, camelize(model_name)]),
        table_up: "CREATE TABLE #{table_name}( \
                      \n\t\t\t\t#{Enum.join(["id serial primary key"] ++ table_fields, ",\n\t\t\t\t")})",
        table_down: "DROP TABLE #{table_name}"
      )
    end

    defp timestamp do
      {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
      "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
    end

    defp pad(i) when i < 10, do: << ?0, ?0 + i >>
    defp pad(i), do: to_string(i)
    
    embed_template :migration, """
    defmodule <%= inspect @mod %> do
      use Ecto.Migration

      def up do
        "<%= @table_up %>"
      end

      def down do
        "<%= @table_down %>"
      end
    end
    """ 

    embed_template :repo, """
    defmodule <%= inspect @repo_module %> do
      use Ecto.Repo, adapter: Ecto.Adapters.Postgres

      def conf do
        parse_url "ecto://<username>:<password>@localhost/<%= @database_name %>"
      end 

      def priv do
        app_dir(:<%= @app_name %>, "priv/repo")
      end 
    end
    """

    embed_template :model, """
    defmodule <%= inspect @model_name %> do
      use Ecto.Model

      schema "<%= @table_name %>" do
        <%= @attributes_table %>
      end 
    end  
    """
  end
end
