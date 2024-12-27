const std = @import("std");
const allocator = std.testing.allocator;
const expect = std.testing.expect;
const assert = std.debug.assert;
const print = std.debug.print;
const ArrayList = std.ArrayList;
const max_size:u8 = 10;
const pow = std.math.pow;

fn get_operators(value:usize, ops:[]u8) void {
    if(ops.len > max_size) unreachable;
    var temp = value;
    for(0..ops.len) |i| {
        //0101
        //0001
        ops[i] = @intCast(temp & 1);
        temp = (temp >> 1);
    }
}

// fn get_operator_fn(op:u8): fn... {
//     unreachable;
// }

fn apply_ops(nums:[]const u8, ops: []const u8) u32 {
    var total:u32 = nums[0];
    for(ops, 1..) |operator, i| {
        switch (operator) {
            0 => total += nums[i],
            1 => total *= nums[i],
            else => unreachable
        }
        // print("total {}\n", .{total});
        if(i >= nums.len-1) break;
    }
    return total;
}

test "apply_ops" {
    const nums = [_]u8{10, 19, 5};
    var ops = [_]u8{0, 0};
    var answer = apply_ops(&nums, &ops);
    // print("answer {}\n", .{answer});
    try expect(answer == 34);

    const nums2 = [_]u8{10, 19, 5, 10};
    const ops2 = [_]u8{0, 0, 1};
    answer = apply_ops(nums2[0..], ops2[0..]);
    // print("answer {}\n", .{answer});
    try expect(answer == 340);
}


fn is_valid(answer:u32, nums:[]const u8) bool {
    const slots:u8 = @intCast(nums.len-1);
    var ops:[max_size]u8 = undefined;
    for(0..pow(u8, 2, slots)) |i| {
        get_operators(i, ops[0..slots]);
        // print("i: {}, ops: {any}\n", .{i, ops});
        const value = apply_ops(nums, &ops);
        if(value == answer) return true;
    }
    return false;
}

test "is_valid" {
    const nums1 = [_]u8{10, 19};
    try expect(is_valid(190, nums1[0..]));

    var nums = [_]u8{11, 6, 16, 20};
    try expect(is_valid(292, nums[0..]));

    nums = [_]u8{11, 5, 16, 20};
    try expect(!is_valid(292, nums[0..]));
}

const trivial =
    \\ 190: 10 19
    \\ 3267: 81 40 27
    \\ 83: 17 5
    \\ 156: 15 6
    \\ 7290: 6 8 6 15
    \\ 161011: 16 10 13
    \\ 192: 17 8 14
    \\ 21037: 9 7 18 13
    \\ 292: 11 6 16 20
;

test "part1 - trivial" {
    // try expect(false);
}

// test "part1" {
//     try expect(false);
// }

// test "part2 - trivial" {
//     try expect(false);
// }

// test "part2" {
//     try expect(false);
// }

test "get_operators" {
    var ops:[10]u8 = undefined;
    get_operators(0, ops[0..1]); // == [0]
    try expect(ops[0] == 0);

    get_operators(1, ops[0..1]); // == [1]
    try expect(ops[0] == 1);

    get_operators(0, ops[0..2]); // == [0 0]
    try expect(ops[0] == 0);
    try expect(ops[1] == 0);

    get_operators(1, ops[0..2]); // == [1 0]
    try expect(ops[0] == 1);
    try expect(ops[1] == 0);

    get_operators(2, &ops); // == [0 1]
    try expect(ops[0] == 0);
    try expect(ops[1] == 1);

    get_operators(3, &ops); // == [1 1]
    try expect(ops[0] == 1);
    try expect(ops[1] == 1);

    get_operators(6, &ops); // == [0 1 1]
    try expect(ops[0] == 0);
    try expect(ops[1] == 1);
    try expect(ops[2] == 1);
}
