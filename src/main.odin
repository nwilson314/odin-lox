package olox

import "core:os"
import "core:fmt"
import "core:strings"

main :: proc() {
    args := os.args[1:]
    fmt.printfln("Args: %v", args)
    if len(args) > 1 {
        fmt.println("Usage: olox [script]")
        os.exit(64)
    } else if len(args) == 1 {
        fmt.printfln("Running file %v", args[0])
        run_file(args[0])
    } else {
        fmt.println("Running prompt")
        run_prompt()
    }
}

run_file :: proc(path: string) {
    data, ok := os.read_entire_file(path, context.allocator)
    if !ok {
        fmt.printfln("There was an error reading the file %v", path)
        os.exit(64)
    }
    defer delete(data, context.allocator)

    string_it := string(data)
    run(string_it)
}

run_prompt :: proc() {
    buf: [256]byte

    for {
        fmt.print("> ")
        num_bytes, err := os.read(os.stdin, buf[:]);
        if err != nil {
            break
        }
        input := strings.trim_space(string(buf[:num_bytes]))
        run(input)
    }
}

run :: proc(source: string) {
    scanner := Scanner {
        source = source
    }
    tokens := scan_tokens(scanner)
}