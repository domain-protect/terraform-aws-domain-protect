locals {
  module_name   = basename(path.module)
  rel_path_root = trimsuffix(path.module, "modules/${local.module_name}") != "" ? trimsuffix(path.module, "modules/${local.module_name}") : "."
}
