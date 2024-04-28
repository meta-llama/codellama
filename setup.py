# Copyright (c) Meta Platforms, Inc. and affiliates.
# This software may be used and distributed according to the terms of the Llama 2 Community License Agreement.

from pkg_resources import parse_requirements
from setuptools import find_packages, setup


def get_requirements(path: str):
    with open(path) as requirements:
        return [r.project_name for r in parse_requirements(requirements)]


setup(
    name="codellama",
    version="0.0.1",
    packages=find_packages(),
    install_requires=get_requirements("requirements.txt"),
)
