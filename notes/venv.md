
# `venv`

The venv module in Python is used for creating lightweight 
"virtual environments," each with its own 
independent set of Python packages installed.  

This allows for isolated project dependencies, preventing conflicts 
between different projects or with the system's global Python installation. 

> [See `venv` documentation](https://docs.python.org/3/library/venv.html)  
> [`venv` tutorial](https://docs.python.org/3/tutorial/venv.html)

## What is a venv?

`venv` = **virtual environment**.

It's basically a *folder* that contains:
- its own Python interpreter
- its own installed packages (`pip install` ... stuff)

So instead of installing packages "globally" on your system, 
each project has its **own little Python world**.

That solves problems like:
- Project A needs `numpy==1.24`
- Project B needs `numpy==2.0`
- System Python belongs to the OS and shouldn't be messed with

**Without venv**: chaos.  
**With venv**: each project is isolated and happy.

---

## Usefulness

- **Isolation** / Per-project dependencies:  
  Prevents package conflicts between different projects.  
  We can break one project's environment without breaking the others.


- **Reproducibility**:  
  Ensures that a project's dependencies are consistent 
  across different machines or environments.  

- **Cleanliness**:  
  Keeps our global Python installation free from project-specific packages.  
  - No sudo / admin nonsense
  - Everything lives in our user folder.
  - No more `sudo pip install ...` mistakes.

---

## Usage

`venv` comes included with Python 3.  
Here's a summary of how `venv` works and its key functionalities

### 1. Creation of Virtual Environments
To create a new virtual environment, 
navigate to your project directory in the terminal and execute
```bash
python3 -m venv <environment_name>
```
Replace `<environment_name>` with your desired name for 
the virtual environment (e.g., `venv` or `env`).  
This creates a directory with that name containing the isolated 
Python installation and package management tools.


### 2. Activation of Virtual Environments
After creation, you need to activate the virtual environment to use it.

```bash
# On macOS/Linux:
source <environment_name>/bin/activate

# On Windows (Command Prompt)
<environment_name>\Scripts\activate.bat

# On Windows (PowerShell)
<environment_name>\Scripts\Activate.ps1
```

Once activated, your terminal prompt will typically change 
to indicate the active environment 
(e.g., `(venv) your_user@your_machine:~/your_project$`).


### 3. Installing Packages
With the virtual environment activated, 
any packages you install using `pip` will be confined to that environment, 
not affecting other projects or the system's global Python.
```bash
pip install <package_name>
```

### 4. Running Scripts With This Environment
```bash
python main.py
```
We'll know it's active because our shell prompt 
usually shows `(.venv)` or similar.

### 5. Deactivation
To exit the virtual environment and return to your system's global Python, 
simply type:
```bash
deactivate
```

> [!WARNING] Important Considerations:  
> - It's common practice to create the virtual environment within 
>   our project's root directory and name it `.venv` or `env`.
> - Exclude the virtual environment directory from our version control system 
>   (e.g., using a `.gitignore` file).
> - Remember to activate the virtual environment 
>   each time we work on a project that uses it.

---

## About `requirements.txt` file

A `requirements.txt` file is used in Python projects to list the project's 
dependencies and their specific versions.  
This ensures that the exact same environment can be recreated 
by anyone working on the project.

Here's an example of a `requirements.txt` file:
```
Django==4.2.7
djangorestframework==3.14.0
requests==2.31.0
numpy==1.26.2
pandas==2.1.4
```

### Explanation:
- Each line specifies a Python package.
- The `==` operator indicates an exact version requirement.  
  This is crucial for reproducibility.
- We can also specify version ranges using operators like 
  `>=` (greater than or equal to), `<=` (less than or equal to), 
  `>` (greater than), `<` (less than), and `!=` (not equal to).  
  For example:
  - `requests>=2.30.0`
  - `Django<5.0`

> [!NOTE] Using a `requirements.txt` file  
> We check in a `requirements.txt`, someone else does:
> ```bash
> python3 -m venv .venv
> source .venv/bin/activate  # or .venv\Scripts\activate on Windows
> pip install -r requirements.txt
> ```
> Boom, same environment as us.

> [!TIP] Generating `requirements.txt`:  
> To create a `requirements.txt` file from an existing environment, 
> activate the environment and run:
> ```bash
> pip freeze > requirements.txt
> ```
> This command outputs the names and versions of all installed packages 
> in the current environment to the `requirements.txt` file.

### [Guide on creating a `requirements.txt` file](https://www.geeksforgeeks.org/python/how-to-create-requirements-txt-file-in-python/)

---

## Do we have to use venv?
No, but we really should for anything beyond tiny throwaway scripts.
