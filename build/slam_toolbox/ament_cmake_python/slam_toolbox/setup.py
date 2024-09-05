from setuptools import find_packages
from setuptools import setup

setup(
    name='slam_toolbox',
    version='2.6.8',
    packages=find_packages(
        include=('slam_toolbox', 'slam_toolbox.*')),
)
