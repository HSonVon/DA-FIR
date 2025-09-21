function fixed_point = fixed_point(float_val, frac_length)
    scaling_factor = 2^frac_length;
    fixed_point_val = round(float_val * scaling_factor);
    max_val = 127;
    min_val = - 128;
    fixed_point = min(max(fixed_point_val, min_val), max_val);
end