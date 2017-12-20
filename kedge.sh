#!/bin/bash

set -eu

usage() {
cat << EOF
This plugin provides integration with the kedge project.

Available Commands:
  build   Build the Kedge files into Kubernetes artifacts, but don't package.
  package Generated a packaged Helm chart.

Typical usage:
   $ draft kedge initialize <app name> <kedge file>
   $ draft up
   $ draft connect

   To apply changes made to Kedge files:
   $ draft kedge update <app name> <kedge file>

EOF
}

initialize() {
  mkdir -p charts/$1
  helm create charts/$1 
  cat > draft.toml << EOF
[environments]
  [environments.development]
    name = "$1"
    wait = false
    namespace = "$(kubectl get secret $(kubectl get sa default -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.namespace}' | base64 -d)"
    watch = false
    watch_delay = 2
EOF

  update $1 $2
}

update() {
  kedge generate -f $2 > charts/$1/templates/kedge-generated.yaml
}

if [[ $# < 1 ]]; then
  echo "===> ERROR: Subcommand required. Try 'draft kedge help'"
  exit 1
fi

case "${1:-"help"}" in
  "update")
    update $2 $3
    ;;
  "initialize")
    initialize $2 $3
    ;;
  "help")
    usage
    ;;
  *)
    echo $1
    usage
    exit 1
    ;;
esac

