const std = @import("std");
const allocator = std.testing.allocator;
const expect = std.testing.expect;
const assert = std.debug.assert;
const print = std.debug.print;

fn is_on_robust(bitmap: *BitMap, x: u32, y: u32) bool {
    return bitmap.is_on(x, y) catch false;
}

const trivial =
    \\47|53
    \\97|13
    \\97|61
    \\97|47
    \\75|29
    \\61|13
    \\75|53
    \\29|13
    \\97|29
    \\53|29
    \\61|53
    \\97|53
    \\61|29
    \\47|13
    \\75|47
    \\97|75
    \\47|61
    \\75|61
    \\47|29
    \\75|13
    \\53|13
    \\
    \\75,47,61,53,29
    \\97,61,53,29,13
    \\75,29,13
    \\75,97,47,61,53
    \\61,13,29
    \\97,13,75,29,47
;

const BitMapError = error {
    IndexTooBig
};

const BitMap = struct {
    nums: u10000 = 0,
    fn get_index(x: u32, y: u32) u14 {
        return @intCast((x*100)+y);
    }
    fn turn_on(self: *BitMap, x: u32, y: u32) BitMapError!void {
        const idx = get_index(x, y);
        if(idx >= 10000) return BitMapError.IndexTooBig;
        const bit:u10000 = 1;
        self.nums = (bit << idx) | self.nums;
    }
    fn is_on(self: *BitMap, x: u32, y: u32) BitMapError!bool {
        const idx = get_index(x, y);
        if(idx >= 10000) return BitMapError.IndexTooBig;
        const bit:u10000 = 1;
        return ((bit << idx) & self.nums) > 0;
    }
};

test "BitMap" {
    var bitmap = BitMap {};
    // print("bitmap size: {}\n", .{@sizeOf(BitMap)});
    try expect(try bitmap.is_on(0, 0) == false);
    try expect(try bitmap.is_on(22, 99) == false);

    if (bitmap.is_on(100, 100)) |_| {
        try expect(false);
    } else |err| switch (err) {
        BitMapError.IndexTooBig =>  { }
    }

    try bitmap.turn_on(99, 99);
    try expect(try bitmap.is_on(99, 99));

    try bitmap.turn_on(0, 0);
    try expect(try bitmap.is_on(0, 0));
}


fn part1(input: []const u8) !u32 {
    var lines_it = std.mem.splitSequence(u8, input, "\n\n");
    const rules = lines_it.next() orelse unreachable;

    // std.debug.print("rules: {s}\n", .{rules});
    var rules_it = std.mem.splitSequence(u8, rules, "\n");
    var bitmap = BitMap {};
    while (rules_it.next()) |rule| {
        // std.debug.print("rule: {s}\n", .{rule});
        var nums_it = std.mem.splitScalar(u8, rule, '|');
        const left = try std.fmt.parseUnsigned(u32, nums_it.next().?, 10);
        const right = try std.fmt.parseUnsigned(u32, nums_it.next().?, 10);
        try bitmap.turn_on(left, right);
    }

    const updates = lines_it.next() orelse unreachable;
    var updates_it = std.mem.splitSequence(u8, updates, "\n");
    var sum: u32 = 0;
    while (updates_it.next()) |update| {
        var nums_it = std.mem.splitScalar(u8, update, ',');
        var prev: ?u32 = null;
        var good = true;
        var nums = std.ArrayList(u32).init(allocator);
        defer nums.deinit();
        while (nums_it.next()) |num_str| {
            const num = try std.fmt.parseUnsigned(u16, num_str, 10);
            defer prev = num;
            try nums.append(num);
            if (prev == null) {
                continue;
            }
            good = good and try bitmap.is_on(prev.?, num);
            if (!good) break;
        }
        if (good) {
            sum += nums.items[(nums.items.len) / 2];
        }
    }
    return sum;
}

fn part2(input: []const u8) !u32 {
    var lines_it = std.mem.splitSequence(u8, input, "\n\n");
    const rules = lines_it.next() orelse unreachable;

    // std.debug.print("rules: {s}\n", .{rules});
    var rules_it = std.mem.splitSequence(u8, rules, "\n");
    var bitmap = BitMap{};
    while (rules_it.next()) |rule| {
        // std.debug.print("rule: {s}\n", .{rule});
        var nums_it = std.mem.splitScalar(u8, rule, '|');
        const left = try std.fmt.parseUnsigned(u32, nums_it.next().?, 10);
        const right = try std.fmt.parseUnsigned(u32, nums_it.next().?, 10);
        try bitmap.turn_on(left, right);
    }

    const updates = lines_it.next() orelse unreachable;
    var updates_it = std.mem.splitSequence(u8, updates, "\n");
    var sum: u32 = 0;
    while (updates_it.next()) |update| {
        var nums_it = std.mem.splitScalar(u8, update, ',');
        var nums = std.ArrayList(u32).init(allocator);
        var prev: ?u32 = null;
        var good = true;
        defer nums.deinit();
        while (nums_it.next()) |num_str| {
            const num = try std.fmt.parseUnsigned(u16, num_str, 10);
            try nums.append(num);
            defer prev = num;
            if (prev == null) continue;
            good = good and try bitmap.is_on(prev.?, num);
        }
        if (good) continue;


        std.mem.sort(u32, nums.items, &bitmap, is_on_robust);

        // std.mem.sort(u32, nums.items, &bitmap, BitMap.is_on);
        const middle = nums.items[(nums.items.len) / 2];
        sum += middle;
    }
    return sum;
}

test "part1 - trivial" {
    const sum = try part1(trivial);
    try expect(sum == 143);
}

test "part1" {
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();
    var buffer: [20000]u8 = undefined;
    // var buffer: [20000]u8 = [_]u8{0} ** 20000;
    const len = try reader.readAll(&buffer);
    // std.debug.print("{}\n", .{len});
    const sum = try part1(buffer[0..(len - 1)]);
    try expect(sum == 5248);
}

test "part2 - trivial" {
    const sum = try part2(trivial);
    // std.debug.print("sum: {}\n", .{sum});
    try expect(sum == 123);
}

test "part2" {
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();
    var buffer: [20000]u8 = undefined;
    const len = try reader.readAll(&buffer);
    // std.debug.print("{}\n", .{len});
    const sum = try part2(buffer[0..(len - 1)]);
    // std.debug.print("{}\n", .{sum});
    try expect(sum == 4507);
}

test "sizes" {
    print("u1 size: {}\n", .{@sizeOf(u1)*8});
    print("u7 size: {}\n", .{@sizeOf(u7)*8});
    print("u8 size: {}\n", .{@sizeOf(u8)*8});
    print("u9 size: {}\n", .{@sizeOf(u9)*8});
    print("u100 size: {}\n", .{@sizeOf(u100)*8});
    print("u128 size: {}\n", .{@sizeOf(u128)*8});
    print("u129 size: {}\n", .{@sizeOf(u129)*8});
}
