// modern-cli-mcp/src/cli.rs
//! Direct CLI tool execution (busybox-style)

use std::process::{Command, Stdio};

/// List of CLI tools that can be executed directly via `modern-cli-mcp <tool> [args...]`
pub const KNOWN_TOOLS: &[&str] = &[
    // Filesystem
    "eza",
    "bat",
    "fd",
    "duf",
    "dust",
    "rip",
    // Search
    "rg",
    "sg",
    "fzf",
    // Git
    "git",
    "gh",
    "glab",
    "delta",
    // Text processing
    "jq",
    "yq",
    "sd",
    "dasel",
    "gron",
    "hck",
    "mlr",
    "htmlq",
    "pup",
    "qsv",
    // System
    "procs",
    "tokei",
    "hyperfine",
    "bats",
    "file",
    // Network
    "xh",
    "doggo",
    "usql",
    "ddgr",
    // Reference
    "tldr",
    "grex",
    "navi",
    // Container
    "podman",
    "docker",
    "dive",
    "skopeo",
    "crane",
    "trivy",
    "buildah",
    // Kubernetes
    "kubectl",
    "helm",
    "kustomize",
    "stern",
    // Archive/Diff
    "ouch",
    "difft",
    "patch",
    "sad",
    // Task queue
    "pueue",
];

/// Check if a string is a known tool name
pub fn is_known_tool(name: &str) -> bool {
    KNOWN_TOOLS.contains(&name)
}

/// Execute a tool directly, passing through stdin/stdout/stderr
pub fn run_tool_directly(tool: &str, args: &[String]) -> ! {
    let status = Command::new(tool)
        .args(args)
        .stdin(Stdio::inherit())
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit())
        .status();

    match status {
        Ok(s) => std::process::exit(s.code().unwrap_or(1)),
        Err(e) => {
            eprintln!("Failed to execute '{}': {}", tool, e);
            std::process::exit(127);
        }
    }
}

/// Print list of available tools for direct execution
pub fn print_tools() {
    println!("Available tools for direct execution:\n");
    println!("Usage: modern-cli-mcp <tool> [args...]\n");

    let categories = [
        (
            "Filesystem",
            &["eza", "bat", "fd", "duf", "dust", "rip"][..],
        ),
        ("Search", &["rg", "sg", "fzf"]),
        ("Git", &["git", "gh", "glab", "delta"]),
        (
            "Text",
            &[
                "jq", "yq", "sd", "dasel", "gron", "hck", "mlr", "htmlq", "pup", "qsv",
            ],
        ),
        ("System", &["procs", "tokei", "hyperfine", "bats", "file"]),
        ("Network", &["xh", "doggo", "usql", "ddgr"]),
        ("Reference", &["tldr", "grex", "navi"]),
        (
            "Container",
            &[
                "podman", "docker", "dive", "skopeo", "crane", "trivy", "buildah",
            ],
        ),
        ("Kubernetes", &["kubectl", "helm", "kustomize", "stern"]),
        ("Archive/Diff", &["ouch", "difft", "patch", "sad"]),
        ("Task Queue", &["pueue"]),
    ];

    for (category, tools) in categories {
        println!("{:<12} {}", category, tools.join(", "));
    }

    println!("\nExamples:");
    println!("  modern-cli-mcp eza -la");
    println!("  modern-cli-mcp rg pattern .");
    println!("  modern-cli-mcp jq '.foo' file.json");
}
