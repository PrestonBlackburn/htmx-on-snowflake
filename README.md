# HTMX + Snowflake App Example

A streamlit killing match made in derp

## Overview
Overal App Structure
```graphql
project/
├── app/
│   ├── templates/          # All HTML templates
│   │   ├── base.html       # Main layout template
│   │   ├── components/     # Reusable HTML fragments
│   │   │   ├── navbar.html
│   │   │   ├── footer.html
│   │   │   ├── modal.html
│   │   │   ├── card.html
│   │   ├── pages/          # Full-page templates
│   │   │   ├── index.html
│   │   │   ├── about.html
│   │   │   ├── contact.html
│   │   ├── htmx/           # HTMX-specific partials
│   │   │   ├── comment_list.html
│   │   │   ├── comment_form.html
│   ├── static/             # CSS, JS, and assets
│   │   ├── css/            # Tailwind input and output files
│   │   │   ├── tailwind.css       # Input file (contains @tailwind directives)
│   │   │   ├── styles.css         # Compiled Tailwind CSS (output file)
│   │   ├── js/             # Custom JavaScript
│   │   │   ├── htmx-extensions.js
│   │   ├── images/         # Images or icons
│   ├── tailwind.config.js  # Tailwind configuration file
│   ├── postcss.config.js   # PostCSS configuration (optional)
│   ├── main.py             # FastAPI entry point
│   ├── routers/            # API and page routers
│   │   ├── home.py
│   │   ├── api.py
│   │   ├── htmx_routes.py
│   ├── models/             # Database models
│   ├── services/           # Business logic
│   ├── utils/              # Utility functions
```

## Setup

### FastAPI
Install requirements
```bash
pip install -r requirements.txt
```

Start the server
```bash
uvicorn app.main:app --port 8000
```

### Stying/JS
From the `tailwind_build/` folder install node deps
```bash
npm init -y
npm install tailwindcss postcss autoprefixer

```

After modifications are made - From the `tailwind_build/` folder 
```bash
npx tailwindcss -i ../app/static/css/tailwind.css -o ../app/static/css/styles.css --watch
```

also get htmx if not yet
```bash
curl -o app/static/js/htmx.min.js https://unpkg.com/htmx.org@1.9.2/dist/htmx.min.js
```