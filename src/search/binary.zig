const std = @import("std");
const print = std.debug.print;
const testing = std.testing;
const meta = std.meta;

fn binary_search(array: []i32, target: i32) ?usize{
    var first: usize = 0;
    var last: usize = array.len;

    while (first <= last) {
        var midpoint = (last - first) / 2;

        if (array[midpoint] == target) {
            return midpoint;
        }
        else if (array[midpoint] < target) {
            first = midpoint + 1;
        }
        else {
            last = midpoint - 1;
        }
    }

    return null;
}


fn auto_binary_search(comptime T: type) fn ([]T, T) ?usize {
    return struct {
        pub fn search(array: []T, target: T) ?usize{
                var first: usize = 0;
                var last: usize = array.len;

                while (first <= last) {
                    var midpoint = (last - first) / 2;

                    if (meta.eql(array[midpoint], target)) {
                        return midpoint;
                    }

                    else if (array[midpoint] < target) {
                        first = midpoint + 1;
                    }
                    else {
                        last = midpoint - 1;
                    }
                }

                return null;
        }
    }.search;
}



test "binary search" {
    var items = [_]i32 {-1, 0, 1, 3, 5, 8, 9, 60};


    try testing.expect(4 == binary_search(items[0..], 5).?);

    try testing.expect(0 == binary_search(items[0..], -1).?);
    try testing.expect(4 == auto_binary_search(i32)(items[0..],  5).?);

}