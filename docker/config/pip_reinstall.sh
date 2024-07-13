#!/bin/bash

### reinstall
pip install python-dateutil==2.8.0
pip install pyzmq==18.0.0
pip install nest-asyncio==1.4.2
pip install jupyter-server==0.0.2
pip install nbformat==5.0.2
pip install nbconvert==5.4.1
pip install Jinja2==2.11.1
pip install markupsafe==2.0.1
pip install importlib-metadata==0.23
pip install traitlets==4.3.2
pip install jupyter-client==6.1.5
pip install tornado==6.0.3
pip install s3transfer==0.2.0
pip install urllib3==1.24.1
pip install MarkupSafe==1.1.1
pip install mistune==0.8.4
pip install preshed==3.0.2
pip install pandas==1.1.2
pip install srsly==2.4.3
pip install typing-extensions==3.7.4.3
pip install Pygments==2.4.1
pip install ipykernel==5.1.0
pip install prompt-toolkit==2.0.9

### uninstall
pip uninstall -y pydantic-core
pip uninstall -y annotated-types
pip uninstall -y keras