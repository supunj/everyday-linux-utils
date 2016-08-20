__author__ = 'Supun Jayathilake (supunj@gmail.com)'

import sys

from pygeocoder import Geocoder


class ProgramParamException(Exception):
    pass


class LatLonUtil():
    @staticmethod
    def derive(val, val_ref):
        _d_m_s = val.split(',')

        _degrees = eval(_d_m_s[0])
        _minutes = eval(_d_m_s[1])
        _seconds = eval(_d_m_s[2])

        # Calculate lat/lon
        _lat_lon_tmp = _degrees + _minutes / 60 + _seconds / 3600

        if val_ref in ('N', 'E'):
            _lat_lon = 0 + _lat_lon_tmp
        else:
            _lat_lon = 0 - _lat_lon_tmp

        return _lat_lon


class LocationUtil():
    @staticmethod
    def getlocation(lat, lon):
        _location = Geocoder.reverse_geocode(lat, lon)

        return _location


try:
    if __name__ == '__main__':
        # Check if all required parameters are supplied or not
        if sys.argv[1] is None or sys.argv[2] is None or sys.argv[3] is None or sys.argv[4] is None:
            raise ProgramParamException

        _latitude = LatLonUtil.derive(sys.argv[1], sys.argv[2])
        # print(_latitude)
        _longitude = LatLonUtil.derive(sys.argv[3], sys.argv[4])
        # print(_longitude)

        print(LocationUtil.getlocation(_latitude, _longitude), ' - (' + str(_latitude) + ',' + str(_longitude) + ')')

except IndexError:
    print("Please provide lat, lat_ref, lon, lon_ref.")
except ProgramParamException:
    print("Please provide lat, lat_ref, lon, lon_ref.")
finally:
    pass


