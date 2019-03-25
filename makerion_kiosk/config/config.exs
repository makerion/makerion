# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

import_config "#{File.cwd!}/../makerion/config/config.exs"

import_config "config.#{Mix.Project.config()[:target]}.exs"
