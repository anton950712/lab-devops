import { ValidationPipe } from "./validation.pipe";

describe('TitleCasePipe', () => {
  const pipe = new ValidationPipe();

  it('test', () => {
    const val = { balance: 1, currency: "EUR "};

    expect(pipe.transform(val)).toBe(val);
  });
});