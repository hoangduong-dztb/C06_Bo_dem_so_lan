def run_window(samples, threshold):
    assert len(samples) == 256
    return sum(1 for x in samples if x > threshold)


def run():
    T = 100

    # All-zero events.
    assert run_window([100] * 256, T) == 0

    # All events: maximum result must be 256.
    assert run_window([101] * 256, T) == 256

    # Event at cycle 1.
    x = [100] * 256
    x[0] = 101
    assert run_window(x, T) == 1

    # Event at cycle 255.
    x = [100] * 256
    x[254] = 101
    assert run_window(x, T) == 1

    # Event at cycle 256.
    x = [100] * 256
    x[255] = 101
    assert run_window(x, T) == 1

    # Equality is not an exceedance for the mentor convention.
    x = [100] * 256
    assert run_window(x, T) == 0

    # Mixed deterministic pattern.
    x = [101 if (i % 7 == 0) else 100 for i in range(256)]
    expected = sum(1 for i in range(256) if i % 7 == 0)
    assert run_window(x, T) == expected

    print("C06 reference model PASS")


if __name__ == "__main__":
    run()
