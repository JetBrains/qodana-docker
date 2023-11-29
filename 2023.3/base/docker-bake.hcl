group "default" {
  targets = ["debian", "debian-js", "python", "python-js", "dotnet", "go", "js", "php", "rust", "ruby", "cpp", "cdnet"]
}

target "debian" {
  tags = [
      "registry.jetbrains.team/p/sa/containers/qodana:debian-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "debian.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/debian",
  ]
  cache-to = [
    "type=local,dest=docker_cache/debian,mode=max",
  ]
}

target "debian-js" {
  contexts = {
    debianbase = "target:debian"
  }
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:debian-js-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "debian.js.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/debian_js",
  ]
  cache-to = [
    "type=local,dest=docker_cache/debian_js,mode=max",
  ]
}

target "python" {
  contexts = {
    debianbase = "target:debian"
  }
  tags = [
      "registry.jetbrains.team/p/sa/containers/qodana:python-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "python.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/python",
  ]
  cache-to = [
    "type=local,dest=docker_cache/python,mode=max",
  ]
}

target "python-js" {
  contexts = {
    pythonbase = "target:python"
  }
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:python-js-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "python.js.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/python_js",
  ]
  cache-to = [
    "type=local,dest=docker_cache/python_js,mode=max",
  ]
}

target "dotnet" {
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:dotnet-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "dotnet.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/dotnet",
  ]
  cache-to = [
    "type=local,dest=docker_cache/dotnet,mode=max",
  ]
}

target "go" {
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:go-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "go.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/go",
  ]
  cache-to = [
    "type=local,dest=docker_cache/go,mode=max",
  ]
}

target "js" {
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:js-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "js.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/js",
  ]
  cache-to = [
    "type=local,dest=docker_cache/js,mode=max",
  ]
}

target "php" {
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:php-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "php.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/php",
  ]
  cache-to = [
    "type=local,dest=docker_cache/php,mode=max",
  ]
}

target "rust" {
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:rust-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "rust.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/rust",
  ]
  cache-to = [
    "type=local,dest=docker_cache/rust,mode=max",
  ]
}

target "ruby" {
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:ruby-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "ruby.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/ruby",
  ]
  cache-to = [
    "type=local,dest=docker_cache/ruby,mode=max",
  ]
}

target "cpp" {
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:cpp-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "cpp.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/cpp",
  ]
  cache-to = [
    "type=local,dest=docker_cache/cpp,mode=max",
  ]
}

target "cdnet" {
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:cdnet-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "dotnet.community.Dockerfile"
  cache-from = [
    "type=local,src=docker_cache/cdnet",
  ]
  cache-to = [
    "type=local,dest=docker_cache/cdnet,mode=max",
  ]
}
