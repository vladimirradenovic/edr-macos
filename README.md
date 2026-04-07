# macOS EDR (Lightweight Prototype)

A lightweight Endpoint Detection & Response (EDR) prototype for macOS built using zsh scripts and launchd.

## Overview

This project simulates core EDR capabilities by monitoring:

- Process execution
- Network port activity
- File system changes

The goal is to demonstrate detection engineering fundamentals, persistence mechanisms, and system-level visibility on macOS.

## Features

- Process monitoring (new process detection)
- Port monitoring (listening ports / changes)
- File monitoring (filesystem activity)
- Centralized logging
- Persistence via launchd

## Architecture

- **Scripts (zsh):** Detection logic
- **launchd:** Persistence & scheduling
- **Logs:** Local event tracking

## Project Structure

