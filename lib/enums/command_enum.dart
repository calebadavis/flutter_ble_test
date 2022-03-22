enum CommandEnum {
  UNKNOWN,
  DEVICE_STATE,
  DEVICE_ERROR,
  DEVICE_BATTERY,
  QUERY_STATE,
  START,
  STOP,
  QUERY_PRESSURE
}

extension CommandId on CommandEnum {
  int get id {
    switch (this) {
      case CommandEnum.UNKNOWN:
        return 0x0;
      case CommandEnum.DEVICE_STATE:
        return 0x1;
      case CommandEnum.DEVICE_ERROR:
        return 0x2;
      case CommandEnum.DEVICE_BATTERY:
        return 0x3;
      case CommandEnum.QUERY_STATE:
        return 0x21;
      case CommandEnum.START:
        return 0x22;
      case CommandEnum.STOP:
        return 0x23;
      case CommandEnum.QUERY_PRESSURE:
        return 0x24;
      default:
        return -1;
    }
  }

  String get name {
    switch (this) {
      case CommandEnum.UNKNOWN:
        return 'UNKNOWN';
      case CommandEnum.DEVICE_STATE:
        return 'DEVICE_STATE';
      case CommandEnum.DEVICE_ERROR:
        return 'DEVICE_ERROR';
      case CommandEnum.DEVICE_BATTERY:
        return 'DEVICE_BATTERY';
      case CommandEnum.QUERY_STATE:
        return 'QUERY_STATE';
      case CommandEnum.START:
        return 'START';
      case CommandEnum.STOP:
        return 'STOP';
      case CommandEnum.QUERY_PRESSURE:
        return 'QUERY_PRESSURE';
      default:
        return 'UNKNOWN';
    }
  }

  static CommandEnum fromInt(int val) {
    CommandEnum ret;
    switch (val) {
      case 0x0:
        ret = CommandEnum.UNKNOWN;
        break;
      case 0x1:
        ret = CommandEnum.DEVICE_STATE;
        break;
      case 0x2:
        ret = CommandEnum.DEVICE_ERROR;
        break;
      case 0x3:
        ret = CommandEnum.DEVICE_BATTERY;
        break;
      case 0x21:
        ret = CommandEnum.QUERY_STATE;
        break;
      case 0x22:
        ret = CommandEnum.START;
        break;
      case 0x23:
        ret = CommandEnum.STOP;
        break;
      case 0x24:
        ret = CommandEnum.QUERY_PRESSURE;
        break;
      default:
        ret = CommandEnum.UNKNOWN;
        break;
    }
    return ret;
  }


  bool isEqual(int val) {
    return id == val;
  }

}