const std = @import("std");
const allocator = std.testing.allocator;
const expect = std.testing.expect;

test "part1" {

    // get buffered reader
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    // fill left list and right list
    var sum: u32 = 0;
    var buffer: [1000]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buffer, ')')) |line| {
        var muls_iter = std.mem.splitBackwardsSequence(u8, line, "mul(");
        const found_mul = muls_iter.next() orelse continue;
        var nums_iter = std.mem.split(u8, found_mul, ",");
        const found_lnums = nums_iter.next() orelse continue;
        const found_rnums = nums_iter.next() orelse continue;
        if (nums_iter.next() != null) {
            continue; // found too many
        }
        const ileft = std.fmt.parseUnsigned(u32, found_lnums, 10) catch continue;
        const iright = std.fmt.parseUnsigned(u32, found_rnums, 10) catch continue;
        sum += ileft * iright;
        // std.debug.print("\n", .{});
    }

    // std.debug.print("{}\n", .{sum});
    try expect(sum == 187833789);
}

test "part2" {

    // get buffered reader
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    // fill left list and right list
    var sum: u32 = 0;
    var buffer: [1000]u8 = undefined;
    var is_do = true;
    while (try reader.readUntilDelimiterOrEof(&buffer, ')')) |line| {
        if (std.mem.endsWith(u8, line, "don't(")) {
            is_do = false;
            continue;
        }
        if (std.mem.endsWith(u8, line, "do(")) {
            is_do = true;
            continue;
        }
        if (!is_do) {
            continue;
        }
        var muls_iter = std.mem.splitBackwardsSequence(u8, line, "mul(");
        const found_mul = muls_iter.next() orelse continue;
        var nums_iter = std.mem.split(u8, found_mul, ",");
        const found_lnums = nums_iter.next() orelse continue;
        const found_rnums = nums_iter.next() orelse continue;
        if (nums_iter.next() != null) {
            continue; // found too many
        }
        const ileft = std.fmt.parseUnsigned(u32, found_lnums, 10) catch continue;
        const iright = std.fmt.parseUnsigned(u32, found_rnums, 10) catch continue;
        sum += ileft * iright;
    }

    // std.debug.print("{}\n", .{sum});
    try expect(sum == 94455185);
}
