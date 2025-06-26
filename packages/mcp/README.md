# Model Context Protocol (MCP)

## Overview

The Model Context Protocol (MCP) provides a standardized way to define, validate, and interact with AI model contexts across the Zopio codebase. It enables seamless communication between different parts of the application and AI models by providing a consistent interface for context management.

## Module Categories

- **Protocol**: Core protocol definition and validation
- **Server**: MCP server implementation for hosting resources
- **Client**: MCP client for consuming resources from servers
- **Utils**: Utility functions for working with MCP resources

## Usage Guidelines

### Setting up an MCP Server

```typescript
import { MCPServer } from '@repo/mcp';
import { z } from 'zod';

// Define resource schemas
const userSchema = z.object({
  id: z.string(),
  type: z.literal('user'),
  attributes: z.object({
    name: z.string(),
    email: z.string().email(),
    role: z.enum(['admin', 'user', 'guest'])
  }).optional()
});

// Create server configuration
const serverConfig = {
  name: 'UserService',
  description: 'Provides user context for AI models',
  resources: {
    user: MCPServer.createResourceDefinition(userSchema, {
      description: 'User resource',
      examples: [{
        id: 'user-123',
        type: 'user',
        attributes: {
          name: 'John Doe',
          email: 'john@example.com',
          role: 'admin'
        }
      }]
    })
  }
};

// Initialize server
const server = new MCPServer(serverConfig);

// Register resources
server.registerResource({
  id: 'user-123',
  type: 'user',
  attributes: {
    name: 'John Doe',
    email: 'john@example.com',
    role: 'admin'
  }
});
```

### Using the MCP Client

```typescript
import { MCPClient } from '@repo/mcp';

// Initialize client
const client = new MCPClient({
  serverUrl: 'https://mcp-server.example.com'
});

// List available resources
const resources = await client.listResources();

// Read a specific resource
const user = await client.readResource('user', 'user-123');
```

## Installation

```bash
# From the root of your Zopio project
pnpm add @repo/mcp
```

## Development Guidelines

1. All resources must implement the `Resource` interface
2. Use Zod schemas for validation
3. Follow the resource-based architecture pattern
4. Maintain backward compatibility when updating schemas

## Integration Examples

### Integrating with AI Features

```typescript
import { MCPClient, createResource } from '@repo/mcp';

// Create a client to fetch context
const mcpClient = new MCPClient({
  serverUrl: '/api/mcp'
});

// Fetch user context for AI
const userContext = await mcpClient.readResource('user', userId);

// Use context in AI request
const aiResponse = await aiClient.complete({
  prompt: 'Generate a personalized greeting',
  context: {
    user: userContext
  }
});
```

## Documentation References

- [Zod Documentation](https://zod.dev/)
- [JSON:API Specification](https://jsonapi.org/) (inspiration for resource format)

## Contributing Guidelines

1. Add tests for new features
2. Update documentation when making changes
3. Follow the existing code style
4. Create resource examples for new resource types

## License Information

Copyright © Zopio Labs. All rights reserved.
