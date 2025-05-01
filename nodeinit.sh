#!/bin/bash

# ╭─────────────────────────────────────────────────────────────╮
# │                                                             │
# │      _   _           _      ___       _ _                   │
# │     | \ | | ___   __| | ___|_ _|_ __ (_) |_                 │
# │     |  \| |/ _ \ / _` |/ _ \| || '_ \| | __|                │
# │     | |\  | (_) | (_| |  __/| || | | | | |_                 │
# │     |_| \_|\___/ \__,_|\___|___|_| |_|_|\__|                │
# │                                                             │
# │            Created by Risshi • github.com/codeRisshi25      │
# │                        Version 1.1                          │
# ╰─────────────────────────────────────────────────────────────╯
#
# This script sets up a new Node.js backend project with a basic MVC structure.
#
# Features:
# - Creates a complete MVC folder structure
# - Initializes package.json with ES modules support
# - Installs essential and optional dependencies
# - Generates boilerplate files (routes, controllers, services)
# - Sets up environment variables
# - Adds convenient npm scripts for development
#
# Usage:
#   ./nodeinit.sh       # Run in the directory where you want to initialize
#   nodeinit            # If installed globally
#
# The script will automatically detect if you're in a Node.js project when
# changing into directories (if you choose to install it globally).
#

# Loeder function to show progress
show_loader() {
    local pid=$1
    local delay=0.2
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr:$i:1}
        printf "\r\033[K 🚀 %s... [%s]" "${CURRENT_OPERATION}" "$temp"
        i=$(((i + 1) % ${#spinstr}))
        sleep $delay
    done
    printf "\r\033[K ✅ %s\n" "${CURRENT_OPERATION}"
}

install_with_buffer() {
    local command=$1
    local message=$2
    export CURRENT_OPERATION="$message"
    ($command >/dev/null 2>&1) &
    show_loader $!
}

# Check if the script is globally executable
if [ ! -f "/usr/local/bin/$(basename "$0")" ]; then
    echo "Do you want to make this script globally executable? (yes/no)"
    read make_global
    if [ "$make_global" == "yes" ]; then
        script_name=$(basename "$0")
        sudo cp "$0" /usr/local/bin/$script_name
        sudo chmod +x /usr/local/bin/$script_name
        echo "✅ The script is now globally executable as '$script_name'."

        # Create a hook to run the script on project initialization
        sudo bash -c "cat <<EOL > /usr/local/bin/nodeinit-hook
#!/bin/bash
if [ -f \"package.json\" ]; then
    echo \"Node.js project detected. Run NodeInit? (yes/no)\"
    read run_init
    if [ \"\$run_init\" == \"yes\" ]; then
        $script_name
    fi
fi
EOL"
        sudo chmod +x /usr/local/bin/nodeinit-hook

        # Add the hook to bash profile
        if ! grep -q "/usr/local/bin/nodeinit-hook" ~/.bashrc; then
            echo 'if [ -f "/usr/local/bin/nodeinit-hook" ]; then /usr/local/bin/nodeinit-hook; fi' >>~/.bashrc
            echo "✅ Hook added to automatically check for Node.js projects."
        fi
    fi
else
    echo "✅ The script is already globally executable."
fi

# Display header
echo -e "\033[1;92m╔════════════════════════════════════════╗"
echo -e "║           NodeInit by Risshi           ║"
echo -e "╚════════════════════════════════════════╝\033[0m"

# initialise a new Node.js project
install_with_buffer "npm init -y" "Initializing Node.js project"

# install essential dependencies
install_with_buffer "npm install express cors dotenv" "Installing core dependencies"

# optional dependencies
echo "Optional Dependencies:"
echo "Install MongoDB (mongoose)? (yes/no)"
read install_mongo
if [ "$install_mongo" == "yes" ]; then
    install_with_buffer "npm install mongoose" "Installing MongoDB (mongoose)"
fi

echo "Install Firebase (firebase-admin)? (yes/no)"
read install_firebase
if [ "$install_firebase" == "yes" ]; then
    install_with_buffer "npm install firebase-admin" "Installing Firebase Admin SDK"
fi

echo "Install additional dependencies? (yes/no)"
read install_others
if [ "$install_others" == "yes" ]; then
    echo "Enter dependencies (space-separated):"
    read additional_dependencies
    install_with_buffer "npm install $additional_dependencies" "Installing additional dependencies"
fi

# Create project structure
echo "🚀 Creating project structure..."
mkdir -p routes controllers services middlewares config
echo "✅ Folder structure created."

# Create app.js
cat <<EOL >app.js
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import routes from './routes/index.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use('/api', routes);

app.listen(PORT, () => {
    console.log(\`Server running on port \${PORT}\`);
});

export default app;
EOL
echo "✅ Created app.js"

# Create a basic route in routes/index.js
cat <<EOL >routes/index.js
import express from 'express';
import exampleController from '../controllers/exampleController.js';

const router = express.Router();

router.get('/example', exampleController.getExample);

export default router;
EOL
echo "✅ Created routes/index.js"

# Create a basic controller in controllers/exampleController.js
cat <<EOL >controllers/exampleController.js
import exampleService from '../services/exampleService.js';

const getExample = (req, res) => {
    const data = exampleService.getExampleData();
    res.json({ message: 'Example route', data });
};

export default { getExample };
EOL
echo "✅ Created controllers/exampleController.js"

# Create a basic service in services/exampleService.js
cat <<EOL >services/exampleService.js
const getExampleData = () => {
    return { key: 'value' };
};

export default { getExampleData };
EOL
echo "✅ Created services/exampleService.js"

# Create a .env file with placeholder values
cat <<EOL >.env
PORT=3000
DATABASE_URL=your_database_url_here
API_KEY=your_api_key_here
EOL
echo "✅ Created .env file with placeholder values"

# Update package.json to use ES6 modules
if grep -q '"type": "commonjs"' package.json; then
    sed -i 's/"type": "commonjs"/"type": "module"/' package.json
else
    sed -i '/^{/a \  "type": "module",' package.json
fi

if command -v jq &>/dev/null; then
    jq '.scripts = {"test": "echo \"Error: no test specified\" && exit 1", "start": "node app.js", "dev": "nodemon app.js"}' package.json >package.json.tmp && mv package.json.tmp package.json
else
    cp package.json package.json.bak
    sed -i 's/"scripts": {[^}]*}/"scripts": {\n    "test": "echo \\"Error: no test specified\\" && exit 1",\n    "start": "node app.js",\n    "dev": "nodemon app.js"\n  }/' package.json
    if ! node -e "JSON.parse(require('fs').readFileSync('package.json', 'utf8'))" &>/dev/null; then
        echo "⚠️ Error modifying package.json. Restoring backup."
        mv package.json.bak package.json
    else
        rm package.json.bak
    fi
fi

echo "✅ Updated package.json"

# Final message
echo -e "\033[1;32m✅ Node.js MVC Boilerplate Setup Complete!\033[0m"
echo "🚀 Run 'npm start' to launch your application."
echo "🔧 Run 'npm run dev' for development with auto-reload."
