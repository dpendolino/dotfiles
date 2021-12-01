function gcloud-project
  gcloud config set project (gcloud projects list --format="value(projectId)" | fzf)
  gcloud compute config-ssh
end
