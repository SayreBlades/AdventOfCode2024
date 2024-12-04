const std = @import("std");
const allocator = std.testing.allocator;
const expect = std.testing.expect;
const SENTINEL = 999999;

pub fn good_slope(slope: i32) bool {
    return (@abs(slope) >= 1) and (@abs(slope) <= 3);
}

pub fn same_sign(l: i32, r: i32) bool {
    return ((l < 0) and (r < 0)) or ((l > 0) and (r > 0));
}

const NumsIterator = struct {
    nums: []const u32,
    index: isize = -1,
    skip_index: ?usize = null,
    fn next(self: *NumsIterator) ?u32 {
        self.index += 1;
        if (self.skip_index != null and self.skip_index.? == self.index) {
            self.index += 1;
        }
        if (self.index >= self.nums.len) return null;
        return self.nums[@intCast(self.index)];
    }
    fn reset(self: *NumsIterator, skip_index: ?usize) void {
        self.index = -1;
        self.skip_index = skip_index;
    }
};

pub fn is_safe_robust(nums_iter: *NumsIterator) bool {
    // check the nums
    if (is_safe(nums_iter)) {
        return true;
    }

    // check nums, but skip the index that errord
    const skip_index = nums_iter.index;
    nums_iter.reset(@intCast(skip_index));
    if (is_safe(nums_iter)) {
        return true;
    }

    // check nums, but skip one before the index that errord
    if (skip_index >= 1) {
        nums_iter.reset(@intCast(skip_index - 1));
        if (is_safe(nums_iter)) {
            return true;
        }
    }
    return false;
}

pub fn is_safe(nums_iter: *NumsIterator) bool {
    var prev_num = nums_iter.next().?;
    var prev_diff: i32 = SENTINEL; // first time only
    while (nums_iter.next()) |num| {
        const inum: i32 = @intCast(num);
        const iprev: i32 = @intCast(prev_num);
        const diff = inum - iprev;
        const is_good_slope = good_slope(diff);
        const is_same_sign = (same_sign(diff, prev_diff) or prev_diff == SENTINEL);
        if (!is_good_slope or !is_same_sign) {
            return false;
        }
        prev_diff = diff;
        prev_num = num;
    }
    return true;
}

test "part1" {

    // get buffered reader
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    // iterate each line
    var num_safe: u32 = 0;
    var buffer: [100]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var it = std.mem.splitSequence(u8, line, " ");
        var nums = std.ArrayList(u32).init(allocator);
        defer nums.deinit();
        while (it.next()) |snum| {
            const num = try std.fmt.parseUnsigned(u32, snum, 10);
            try nums.append(num);
        }
        var nums_iter = NumsIterator{ .nums = nums.items };
        num_safe += @as(u1, @bitCast(is_safe(&nums_iter)));
    }

    // std.debug.print("{}\n", .{num_safe});
    try expect(num_safe == 639);
}

test "part2" {
    // get buffered reader
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    // iterate each line
    var num_safe: u32 = 0;
    var buffer: [100]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var it = std.mem.splitSequence(u8, line, " ");
        var nums = std.ArrayList(u32).init(allocator);
        defer nums.deinit();
        while (it.next()) |snum| {
            const num = try std.fmt.parseUnsigned(u32, snum, 10);
            try nums.append(num);
        }
        var nums_iter = NumsIterator{ .nums = nums.items };
        const safe = is_safe_robust(&nums_iter);
        num_safe += @as(u1, @bitCast(safe));
    }

    // std.debug.print("{}\n", .{num_safe});
    try expect(num_safe == 674);
}
