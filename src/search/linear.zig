const std = @import("std");
const print = std.debug.print;
const testing = std.testing;
const meta = std.meta;

pub fn linear_search_i32(array: []i32, value: i32) ?usize {
    for (array) |v, idx| {
        if (value == v) return idx;
    }
    return null;
}

/// generic linear search
/// T: type of element
/// compare: compare function, takes two arguments of type T
/// and returns true if the arguments are equal else false
pub fn linear_search(comptime T: type, comptime compare: fn (T, T) bool) fn ([]T, T) ?usize {
    return struct {
        pub fn search(array: []T, value: T) ?usize {
            for (array) |v, idx| {
                if (compare(value, v)) return idx;
            }
            return null;
        }
    }.search;
}

pub fn compare_i64(x: i64, y: i64) bool {
    return x == y;
}

pub fn auto_linear_search(comptime T: type) fn ([]T, T) ?usize {
    return struct {
        pub fn search(array: []T, value: T) ?usize {
            for (array) |v, idx| {
                if (meta.eql(value, v)) return idx;
            }
            return null;
        }
    }.search;
}

test "search test" {
    var array = [_]i64{ 1, 2, 3, 4, 5, 6, 7 };
    const search = linear_search(i64, compare_i64);

    try testing.expect(3 == search(array[0..], 4).?);
    try testing.expect(search(array[0..], 10) == null);

    const auto_search = auto_linear_search(i64);
    try testing.expect(3 == auto_search(array[0..], 4).?);
    try testing.expect(auto_search(array[0..], 10) == null);

    var names = [_][] const u8{"jane", "doe", "john", "foo", "bar", "baz"};
    const search_name = auto_linear_search([]const u8);

    try testing.expect(@as(usize, 2) == search_name(names[0..], "john"));

    
}
