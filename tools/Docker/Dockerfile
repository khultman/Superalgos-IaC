
docker run -d -it --name terraform --entrypoint "/usr/bin/tail" -v $(pwd):/workspace -w /workspace hashicorp/terraform:light sh tail -f /dev/null


docker exec -it terraform sh