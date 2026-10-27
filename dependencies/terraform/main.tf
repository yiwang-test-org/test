module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace = "inventory"
  name      = "fixture"
}

resource "random_pet" "name" {
  prefix = module.label.id
}

resource "null_resource" "noop" {
  triggers = {
    name = random_pet.name.id
  }
}
