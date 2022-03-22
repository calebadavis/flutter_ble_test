enum DeviceState {
  INVALID,
  IDLE,
  INFLATING,
  HOLD_PRESSURE,
  DEFLATING
}

extension DeviceStateId on DeviceState {
  int get id {
    switch (this) {
      case DeviceState.INVALID:
        return 0;
      case DeviceState.IDLE:
        return 1;
      case DeviceState.INFLATING:
        return 2;
      case DeviceState.HOLD_PRESSURE:
        return 3;
      case DeviceState.DEFLATING:
        return 4;
      default:
        return 0;
    }
  }

  static DeviceState fromInt(int val) {
    DeviceState ret;
    switch (val) {
      case 0x0:
        ret = DeviceState.INVALID;
        break;
      case 0x1:
        ret = DeviceState.IDLE;
        break;
      case 0x2:
        ret = DeviceState.INFLATING;
        break;
      case 0x3:
        ret = DeviceState.HOLD_PRESSURE;
        break;
      case 0x4:
        ret = DeviceState.DEFLATING;
        break;
      default:
        ret = DeviceState.INVALID;
    }
    return ret;
  }

  bool isEqual(int val) {
    return id == val;
  }

}