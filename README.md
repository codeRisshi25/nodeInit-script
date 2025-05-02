```
 _   _           _      ___       _ _   
| \ | | ___   __| | ___|_ _|_ __ (_) |_ 
|  \| |/ _ \ / _` |/ _ \| || '_ \| | __|
| |\  | (_) | (_| |  __/| || | | | | |_ 
|_| \_|\___/ \__,_|\___|___|_| |_|_|\__|
```

NodeInit is a streamlined script designed to initialize Node.js projects with an MVC architecture quickly and efficiently. This tool sets up a standardized project structure with essential configurations to help you start coding right away.

<img alt="Version" src="https://img.shields.io/badge/Version-1.2-brightgreen">
<img alt="Bash" src="https://img.shields.io/badge/Shell-Bash-blue">
<img alt="License" src="https://img.shields.io/badge/License-MIT-yellow">

## Features

- Creates a complete MVC folder structure (routes, controllers, services, middlewares)
- Initializes Node.js project with ES modules support
- Installs essential dependencies (express, cors, dotenv)
- Offers optional installations (MongoDB, Firebase, custom dependencies)
- Generates boilerplate files (routes, controllers, services)
- Sets up environment variables
- Configures convenient npm scripts for development
- Option to install globally for easy access

## Installation

### Option 1: Clone the repository
```bash
# Clone the repository
git clone https://github.com/codeRisshi25/nodeInit-script.git
cd nodeInit-script
chmod +x nodeInit.sh
```

### Option 2: Direct download
```bash
# Download with curl
curl -O https://raw.githubusercontent.com/codeRisshi25/nodeInit-script/main/nodeInit.sh
chmod +x nodeInit.sh
```


## Usage

```bash
# Initialize in current directory
./nodeinit.sh
# Create a new directory and initialize there
./nodeinit.sh my-project
# If installed globally, initialize in current directory
nodeinit
# If installed globally, create directory and initialize
nodeinit my-project          
```

## Project Structure

The script creates the following structure:

```
project-name/
├── routes/
│   └── index.js
├── controllers/
│   └── exampleController.js
├── services/
│   └── exampleService.js
├── middlewares/
├── config/
├── .env
├── app.js
└── package.json
```

## Contributing

Contributions are welcome and appreciated! Here's how you can contribute:

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add some amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

Whether it's fixing bugs, improving documentation, or suggesting new features - all contributions help make NodeInit better for everyone.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Created by [Risshi](https://github.com/codeRisshi25)
