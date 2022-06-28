package com.rhms;

public enum Restrict {
    ADMIN, HOME, GUEST, ME, SEARCH, USERS, FILTER;
    private static Restrict restrict;
    private static Restrict subRestrict;

    public static Restrict getRestrict() {
        return restrict;
    }

    public static void setRestrict(Restrict restrict) {
        Restrict.restrict = restrict;
    }

    public static Restrict getSubRestrict() {
        return subRestrict;
    }

    public static void setSubRestrict(Restrict subRestrict) {
        Restrict.subRestrict = subRestrict;
    }
}
