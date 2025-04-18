group "all" {
  targets = ["jvm-community", "jvm", "python", "python-community", "other", "cpp", "cpp-community", "ruby3x", "dotnet", "dotnet-community"]
}

group "default" {
  targets = ["jvm-community", "jvm", "python-community", "python", "dotnet-community", "dotnet"]
}

group "more" {
  targets = ["other"]
}

group "clang" {
  targets = ["cpp", "cpp-community"]
}

group "ruby" {
  targets = ["ruby3x"]
}

target "jvm-community" {
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:jvm-community-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "jvm-community.Dockerfile"
}

target "jvm" {
  contexts = {
    jvm-community = "target:jvm-community"
  }
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:jvm-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "jvm.Dockerfile"
}

target "python-community" {
  contexts = {
    jvm-community = "target:jvm-community"
  }
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:python-community-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "python-community.Dockerfile"
}

target "python" {
  contexts = {
    python-community = "target:python-community"
  }
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:python-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "python.Dockerfile"
}

target "other" {
  name = "${edition}-base-latest"
  matrix = {
    edition = ["go", "js", "php", "rust", "ruby"]
  }
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:${edition}-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "${edition}.Dockerfile"
}

target "cpp-community" {
  matrix = {
    clang = ["15", "16", "17", "18"]
  }
  name = "cpp-community-${clang}-latest"
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:cpp-community-base-${clang}-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "cpp-community.Dockerfile"
  args = {
    CLANG = clang
  }
}

target "cpp" {
  contexts = {
    cpp-community = "target:cpp-community-${clang}-latest"
  }
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

target "dotnet-community" {
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:dotnet-community-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "dotnet-community.Dockerfile"
}

target "dotnet" {
  contexts = {
    dotnet-community = "target:dotnet-community"
  }
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:dotnet-base-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "dotnet.Dockerfile"
}

target "ruby3x" {
  matrix = {
    version = ["1", "2", "3", "4"]
  }
  name = "ruby-base-3${version}"
  tags = [
    "registry.jetbrains.team/p/sa/containers/qodana:ruby-base-3.${version}-latest"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  dockerfile = "ruby.Dockerfile"
  args = {
    RUBY_TAG = "3.${version}-slim-bookworm"
  }
}