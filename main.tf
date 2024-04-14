# gcloud auth login
# https://console.cloud.google.com/welcome?project=delta-fact-282601 (ID->delta-fact-282601)
# habilitar compute Engiene: gcloud services enable compute.googleapis.com --project=delta-fact-282601
# gcloud services disable compute.googleapis.com --project=delta-fact-282601

# saber imagenes de ubuntu tiene (gcloud compute images list)

provider "google" {
  # No es necesario especificar el archivo de credenciales cuando se usa la autenticación predeterminada de aplicación de Google Cloud
  project = "delta-fact-282601" # Reemplaza "your-project-id" con el ID de tu proyecto en GCP
  region  = "us-central1"       # Región de GCP que prefieras
}

resource "google_compute_network" "example_network" {
  name = "my-network"
}

resource "google_compute_instance" "example_instance" {
  name         = "my-instance"
  machine_type = "n1-standard-1" # Tipo de máquina en GCP
  zone         = "us-central1-a" # Zona de GCP que prefieras
  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2204-lts" # Imagen de Ubuntu en GCP
    }
  }
  network_interface {
    network = google_compute_network.example_network.self_link
    access_config {}
  }
}


# para que terraform no te pida el yes.
# terraform init -upgrade
# terraform apply -auto-approve
# terraform destroy -auto-approve

# par el ip (gcloud compute instances describe my-instance --project=delta-fact-282601 --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
