const std = @import("std");
const allocator = std.testing.allocator;
const expect = std.testing.expect;
const trivial =
    \\MMMSXXMASM
    \\MSAMXMSMSA
    \\AMXSXMAAMM
    \\MSAMASMSMX
    \\XMASAMXAMM
    \\XXAMMXXAMA
    \\SMSMSASXSS
    \\SAXAMASAAA
    \\MAMMMXMMMM
    \\MXMXAXMASX
;

fn check_cell(comptime rows: comptime_int, comptime cols: comptime_int, lines: [rows][cols]u8, row_index: i16, col_index: i16, char: u8) bool {
    if (row_index < 0 or row_index >= rows) return false;
    if (col_index < 0 or col_index >= cols) return false;
    const val: u8 = lines[@intCast(row_index)][@intCast(col_index)];
    const res: bool = val == char;
    return res;
}

fn findXMAS(comptime rows: comptime_int, comptime cols: comptime_int, lines: [rows][cols]u8) u16 {
    var found: u16 = 0;
    for (lines, 0..) |row, rowi| {
        const row_index: i16 = @intCast(rowi);
        for (row, 0..) |cell, coli| {
            const col_index: i16 = @intCast(coli);
            if (cell == 'X') {
                // search horizontal
                if ((check_cell(rows, cols, lines, row_index, col_index + 1, 'M') and
                    (check_cell(rows, cols, lines, row_index, col_index + 2, 'A') and
                    (check_cell(rows, cols, lines, row_index, col_index + 3, 'S')))))
                {
                    found += 1;
                }
                // search vertical
                if ((check_cell(rows, cols, lines, row_index + 1, col_index, 'M') and
                    (check_cell(rows, cols, lines, row_index + 2, col_index, 'A') and
                    (check_cell(rows, cols, lines, row_index + 3, col_index, 'S')))))
                {
                    found += 1;
                }
                // search diagnal down
                if ((check_cell(rows, cols, lines, row_index + 1, col_index + 1, 'M') and
                    (check_cell(rows, cols, lines, row_index + 2, col_index + 2, 'A') and
                    (check_cell(rows, cols, lines, row_index + 3, col_index + 3, 'S')))))
                {
                    found += 1;
                }
                // search rhorizontal
                if ((check_cell(rows, cols, lines, row_index, col_index - 1, 'M') and
                    (check_cell(rows, cols, lines, row_index, col_index - 2, 'A') and
                    (check_cell(rows, cols, lines, row_index, col_index - 3, 'S')))))
                {
                    found += 1;
                }
                // search rvertical
                if ((check_cell(rows, cols, lines, row_index - 1, col_index, 'M') and
                    (check_cell(rows, cols, lines, row_index - 2, col_index, 'A') and
                    (check_cell(rows, cols, lines, row_index - 3, col_index, 'S')))))
                {
                    found += 1;
                }
                // search rdiagnal down
                if ((check_cell(rows, cols, lines, row_index - 1, col_index - 1, 'M') and
                    (check_cell(rows, cols, lines, row_index - 2, col_index - 2, 'A') and
                    (check_cell(rows, cols, lines, row_index - 3, col_index - 3, 'S')))))
                {
                    found += 1;
                }
                // search diagnal up
                if ((check_cell(rows, cols, lines, row_index - 1, col_index + 1, 'M') and
                    (check_cell(rows, cols, lines, row_index - 2, col_index + 2, 'A') and
                    (check_cell(rows, cols, lines, row_index - 3, col_index + 3, 'S')))))
                {
                    found += 1;
                }
                // search rdiagnal up
                if ((check_cell(rows, cols, lines, row_index + 1, col_index - 1, 'M') and
                    (check_cell(rows, cols, lines, row_index + 2, col_index - 2, 'A') and
                    (check_cell(rows, cols, lines, row_index + 3, col_index - 3, 'S')))))
                {
                    found += 1;
                }
            }
        }
        // std.debug.print("\n", .{});
    }
    return found;
}

fn findMAS(comptime rows: comptime_int, comptime cols: comptime_int, lines: [rows][cols]u8) u16 {
    var found: u16 = 0;
    for (lines, 0..) |row, rowi| {
        const row_index: i16 = @intCast(rowi);
        for (row, 0..) |_, coli| {
            const col_index: i16 = @intCast(coli);
            // search M's
            if ((check_cell(rows, cols, lines, row_index + 0, col_index + 0, 'M') and
                (check_cell(rows, cols, lines, row_index + 1, col_index + 1, 'A') and
                (check_cell(rows, cols, lines, row_index + 2, col_index + 2, 'S')))))
            {
                if ((check_cell(rows, cols, lines, row_index + 0, col_index + 2, 'M') and
                    (check_cell(rows, cols, lines, row_index + 2, col_index + 0, 'S'))))
                {
                    found += 1;
                    continue;
                }
                if ((check_cell(rows, cols, lines, row_index + 0, col_index + 2, 'S') and
                    (check_cell(rows, cols, lines, row_index + 2, col_index + 0, 'M'))))
                {
                    found += 1;
                    continue;
                }
            }
            // search S's
            if ((check_cell(rows, cols, lines, row_index + 0, col_index + 0, 'S') and
                (check_cell(rows, cols, lines, row_index + 1, col_index + 1, 'A') and
                (check_cell(rows, cols, lines, row_index + 2, col_index + 2, 'M')))))
            {
                if ((check_cell(rows, cols, lines, row_index + 0, col_index + 2, 'M') and
                    (check_cell(rows, cols, lines, row_index + 2, col_index + 0, 'S'))))
                {
                    found += 1;
                    continue;
                }
                if ((check_cell(rows, cols, lines, row_index + 0, col_index + 2, 'S') and
                    (check_cell(rows, cols, lines, row_index + 2, col_index + 0, 'M'))))
                {
                    found += 1;
                    continue;
                }
            }
        }
        // std.debug.print("\n", .{});
    }
    return found;
}

test "part1 - trivial" {
    // get the input
    const rows = 10;
    const cols = 11; // including newline
    const lines = @as([rows][cols]u8, @bitCast(trivial[0..].*));

    // reshape and find all XMAS
    const found = findXMAS(rows, cols, lines);
    try expect(found == 18);
}

test "part1" {
    // get buffered reader
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    // get the input
    const rows = 140;
    const cols = 141; // including newline
    var line: [rows * cols]u8 = undefined;
    _ = try reader.readAll(&line);

    // reshape and find all XMAS
    const lines = @as([rows][cols]u8, @bitCast(line));
    const found = findXMAS(rows, cols, lines);
    try expect(found == 2447);
}

test "part2 - trivial" {
    // get the input
    const rows = 10;
    const cols = 11; // including newline
    const lines = @as([rows][cols]u8, @bitCast(trivial[0..].*));

    // reshape and find all MAS
    const found = findMAS(rows, cols, lines);
    try expect(found == 9);
}

test "part2" {
    // get buffered reader
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    // get the input
    const rows = 140;
    const cols = 141; // including newline
    var line: [rows * cols]u8 = undefined;
    _ = try reader.readAll(&line);

    // reshape and find all XMAS
    const lines = @as([rows][cols]u8, @bitCast(line));
    const found = findMAS(rows, cols, lines);
    try expect(found == 1868);
}
