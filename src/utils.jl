should_path_be_processed(path::AbstractString) =
    any(startswith("."), splitpath(path))

const KNOWN_PROJECT_FILE_NAMES = [
    "Project.toml"
    "Cargo.toml"
    "build.gradle"
    "settings.gradle"
    "Gemfile"
] |> Set

is_project_file(fn::AbstractString) =
    splitpath(fn)[end] in KNOWN_PROJECT_FILE_NAMES
