use Mix.Config

if File.exists?("rpi3.secret.exs") do
  import_config "rpi3.secret.exs"
end
