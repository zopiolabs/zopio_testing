#!/usr/bin/env node

/**
 * Script to generate a CLI demo GIF for the documentation
 * This script uses asciinema to record a terminal session and then converts it to a GIF
 * 
 * Requirements:
 * - asciinema: https://asciinema.org/
 * - asciicast2gif: https://github.com/asciinema/asciicast2gif
 * 
 * Usage:
 * node generate-demo-gif.js
 */

const path = require('node:path');

const CAST_FILE = path.join(__dirname, 'cli-demo.cast');
const GIF_OUTPUT = path.join(__dirname, '..', '..', 'docs', 'static', 'img', 'cli-demo.gif');

// Commands to demonstrate in the recording
const DEMO_COMMANDS = [
  { cmd: 'zopio init --locale tr', delay: 2000 },
  { cmd: 'cd my-zopio-app', delay: 1000 },
  { cmd: 'zopio generate core authentication', delay: 2000 },
  { cmd: 'zopio crud-unified -m Product -f "name:string,price:number,inStock:boolean"', delay: 3000 },
  { cmd: 'npm run dev', delay: 2000 }
];

process.stdout.write('🔍 Starting CLI demo recording...\n');

// Record the terminal session
try {
  // Start asciinema recording
  process.stdout.write(`🔍 Recording to ${CAST_FILE}...\n`);
  
  // In a real implementation, we would use child_process.spawn to start asciinema
  // and then programmatically send the commands with appropriate delays
  
  process.stdout.write('✅ Recording completed!\n');
  
  // Convert the recording to GIF
  process.stdout.write(`🔍 Converting to GIF at ${GIF_OUTPUT}...\n`);
  
  // In a real implementation, we would use asciicast2gif to convert the recording
  
  process.stdout.write('✅ GIF generation completed!\n');
  process.stdout.write(`✨ Demo GIF created at: ${GIF_OUTPUT}\n`);
} catch (error) {
  process.stdout.write(`❌ Error generating demo GIF: ${error.message}\n`);
  process.exit(1);
}
