use Mix.Config

if File.exists?("rpi3a.secret.exs") do
  import_config "rpi3a.secret.exs"
end
