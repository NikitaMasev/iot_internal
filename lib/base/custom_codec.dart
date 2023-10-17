abstract interface class CustomCodec<D, E> {
  E decode(final D data);

  D encode(final E data);
}
