import torch
import importlib
import importlib.metadata
import os
import warnings
from functools import lru_cache

from packaging import version
from packaging.version import parse



def is_ipex_available():
    def get_major_and_minor_from_version(full_version):
        return str(version.parse(full_version).major) + "." + str(version.parse(full_version).minor)

    _torch_version = importlib.metadata.version("torch")
    if importlib.util.find_spec("intel_extension_for_pytorch") is None:
        return False
    _ipex_version = "N/A"
    try:
        _ipex_version = importlib.metadata.version("intel_extension_for_pytorch")
    except importlib.metadata.PackageNotFoundError:
        return False
    torch_major_and_minor = get_major_and_minor_from_version(_torch_version)
    ipex_major_and_minor = get_major_and_minor_from_version(_ipex_version)
    if torch_major_and_minor != ipex_major_and_minor:
        warnings.warn(
            f"Intel Extension for PyTorch {ipex_major_and_minor} needs to work with PyTorch {ipex_major_and_minor}.*,"
            f" but PyTorch {_torch_version} is found. Please switch to the matching version and run again."
        )
        return False
    return True


@lru_cache
def is_xpu_available(check_device=False):
    "Checks if `intel_extension_for_pytorch` is installed and potentially if a XPU is in the environment"
    if not is_ipex_available():
        return False

    import intel_extension_for_pytorch  # noqa: F401
    
    if check_device:
        try:
            # Will raise a RuntimeError if no XPU  is found
            _ = torch.xpu.device_count()
            return torch.xpu.is_available()
        except RuntimeError:
            return False
    return hasattr(torch, "xpu") and torch.xpu.is_available()


def is_ccl_available():
    ccl_version = "N/A"
    try:
        _is_ccl_available = (
            importlib.util.find_spec("torch_ccl") is not None
            or importlib.util.find_spec("oneccl_bindings_for_pytorch") is not None
        )
        
        ccl_version = importlib.metadata.version("oneccl_bind_pt")
        print(f"Detected oneccl_bind_pt version {ccl_version}")
    except importlib.metadata.PackageNotFoundError:
        _is_ccl_available = False
        return False
    return _is_ccl_available
