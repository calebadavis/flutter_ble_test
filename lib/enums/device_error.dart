enum DeviceError {
  INVALID,
  PRESSURE_HIGH,
  ERRATIC_INFLATION,
  NO_AIRBAG
}

extension DeviceErrorId on DeviceError {
  int get id {
    switch (this) {
      case DeviceError.INVALID:
        return 0;
      case DeviceError.PRESSURE_HIGH:
        return 1;
      case DeviceError.ERRATIC_INFLATION:
        return 2;
      case DeviceError.NO_AIRBAG:
        return 3;
      default:
        return 0;
    }
  }

  static DeviceError fromInt(int val) {
    DeviceError ret;
    switch (val) {
      case 0x0:
        ret = DeviceError.INVALID;
        break;
      case 0x1:
        ret = DeviceError.PRESSURE_HIGH;
        break;
      case 0x2:
        ret = DeviceError.ERRATIC_INFLATION;
        break;
      case 0x3:
        ret = DeviceError.NO_AIRBAG;
        break;
      default:
        ret = DeviceError.INVALID;
    }
    return ret;
  }

  bool isEqual(int val) {
    return id == val;
  }
}