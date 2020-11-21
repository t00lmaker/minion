ENV["KEMAL_ENV"] = "test"
ENV["MINION_CONFIG_FILE"]="spec/assets/minion.yml"

require "spec"
require "../src/*"
