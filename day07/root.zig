const std = @import("std");
const allocator = std.testing.allocator;
const expect = std.testing.expect;
const assert = std.debug.assert;
const print = std.debug.print;
const ArrayList = std.ArrayList;
const max_size:u8 = 10;
const pow = std.math.pow;

/// input: nums - list of numbers; operands
/// input: ops - operators to apply to operands
/// return: the sum of the operators applied to the operands
///
/// Ops is reverse bitwise encoded, such that the number 4:
/// 4 == 0b100 is effectively reversed 001 and each bit
/// represents encoded such that 0=='+' and 1=='*'
fn apply_ops(nums:[]const u8, ops:u16) u32 {
    var total:u32 = nums[0];
    // print("total {}\n", .{total});
    for(1..(nums.len)) |i| {
        const slot:u4 = @intCast(i-1);
        const operator:u1 = @intCast((ops >> slot) & 1);
        // print("operator {}\n", .{operator});
        switch (operator) {
            0 => total += nums[i],
            1 => total *= nums[i],
        }
        // print("total {}\n", .{total});
        if(i >= nums.len-1) break;
    }
    return total;
}

test "apply_ops" {
    const nums = [_]u8{10, 19, 5};
    var ops:u16 = 0; // 0b00 == [0 0] == [+ +]
    var answer = apply_ops(&nums, ops);
    // print("answer {}\n\n", .{answer});
    try expect(answer == 34);

    ops = 1; // 0b01 == [1 0] == [* +]
    answer = apply_ops(&nums, ops);
    // print("answer {}\n\n", .{answer});
    try expect(answer == 195);

    ops = 2; // 0b10 == [0 1] == [+ *]
    answer = apply_ops(&nums, ops);
    // print("answer {}\n\n", .{answer});
    try expect(answer == 145);

    ops = 3; // 0b11 == [1 1] == [* *]
    answer = apply_ops(&nums, ops);
    // print("answer {}\n\n", .{answer});
    try expect(answer == 950);

    const nums2 = [_]u8{10, 19, 5, 10};
    ops = 1; // 0b001 == [1 0 0] == [* + +]
    answer = apply_ops(&nums2, ops);
    // print("answer {}\n", .{answer});
    try expect(answer == 205);
}


/// runs through all the permutations of operators
/// to determine if they can be applied to the
/// operands such that the expected 'answer' is valid
fn is_valid(answer:u32, nums:[]const u8) bool {
    const slots:u8 = @intCast(nums.len-1);
    for(0..pow(u8, 2, slots), 0..) |_, ops| {
        // get_operators(i, ops);
        // print("i: {}, ops: {any}\n", .{i, ops});
        const value = apply_ops(nums, @intCast(ops));
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
