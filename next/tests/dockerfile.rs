#[cfg(test)]
mod tests {
    use std::fs;

    #[test]
    fn docker_files_have_same_logic() {
        let internal = fs::read_to_string("dotnet/internal.Dockerfile");
        let base = fs::read_to_string("base/dotnet.Dockerfile");

        assert_eq!(result, 4);
    }
}