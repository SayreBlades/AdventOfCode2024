const std = @import("std");
const allocator = std.testing.allocator;
const expect = std.testing.expect;

test "part1" {

    // create two lists
    var left_nums = std.ArrayList(u32).init(allocator);
    var right_nums = std.ArrayList(u32).init(allocator);
    defer left_nums.deinit();
    defer right_nums.deinit();

    // get buffered reader
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    // fill left list and right list
    var buffer: [100]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var it = std.mem.splitSequence(u8, line, "  ");

        // get left number
        const sleft = std.mem.trim(u8, it.next().?, " ");
        const ileft = try std.fmt.parseUnsigned(u32, sleft, 10);
        try left_nums.append(ileft);

        // get right number
        const sright = std.mem.trim(u8, it.next().?, " ");
        const iright = try std.fmt.parseUnsigned(u32, sright, 10);
        try right_nums.append(iright);
        // std.debug.print("-{}-{}-\n", .{ ileft, iright });
    }

    // sort both lists
    std.mem.sort(u32, left_nums.items, {}, comptime std.sort.asc(u32));
    std.mem.sort(u32, right_nums.items, {}, comptime std.sort.asc(u32));

    // sum diffs
    var sum: u64 = 0;
    for (left_nums.items, right_nums.items) |left, right| {
        // std.debug.print("-{}-{}-\n", .{ left, right });
        const ileft: i64 = left;
        const iright: i64 = right;
        sum = sum + @abs(ileft - iright);
    }

    // std.debug.print("part 1 - sum {}\n", .{sum});
    try expect(sum == 3508942);
}

test "part2" {

    // create two lists
    var left_nums = std.ArrayList(u32).init(allocator);
    var right_nums = std.ArrayList(u32).init(allocator);
    defer left_nums.deinit();
    defer right_nums.deinit();

    // get buffered reader
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    // fill left list and right list
    var buffer: [100]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var it = std.mem.splitSequence(u8, line, "  ");

        // get left number
        const sleft = std.mem.trim(u8, it.next().?, " ");
        const ileft = try std.fmt.parseUnsigned(u32, sleft, 10);
        try left_nums.append(ileft);

        // get right number
        const sright = std.mem.trim(u8, it.next().?, " ");
        const iright = try std.fmt.parseUnsigned(u32, sright, 10);
        try right_nums.append(iright);
        // std.debug.print("-{}-{}-\n", .{ ileft, iright });
    }

    // multipliers
    var mults: [99999]u8 = undefined;
    @memset(&mults, 0);

    // iterate through right and sum
    for (right_nums.items) |num| {
        mults[num] += 1;
    }

    // sum similarities
    var sum: u64 = 0;
    for (left_nums.items) |num| {
        sum += num * mults[num];
    }

    // std.debug.print("part 2 - sum {}\n", .{sum});
    try expect(sum == 26593248);
}
