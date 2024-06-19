group "all" {
  targets = ["debian", "debian-js", "python", "python-js", "other"]
}

group "default" {
  targets = ["debian", "debian-js", "python", "python-js"]
}

group "more" {
  targets = ["other"]
}

group "clang" {
  targets = ["cpp"]
}

target "debian" {
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:debian-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "debian.Dockerfile"
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
}

target "other" {
  name = "${edition}-base-latest"
  matrix = {
    edition = ["dotnet", "go", "js", "php", "rust", "ruby", "cdnet"]
  }
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:${edition}-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "${edition}.Dockerfile"
}

target "cpp" {
  matrix = {
    clang = ["15", "16", "17", "18"]
  }
  name = "cpp-base-${clang}-latest"
  tags = [
      "registry.jetbrains.team/p/sa/containers/qodana:cpp-base-${clang}-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "cpp.Dockerfile"
  args = {
    CLANG = clang
  }
}