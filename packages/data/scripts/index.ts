/**
 * @repo/data/scripts
 * 
 * This module contains utility scripts for the data package.
 * It may be used for data migrations, setup scripts, or other utilities
 * that are needed for the data package but are not part of the core API.
 */

// Export any script utilities or functions here
export const version = '0.1.0';

// Example utility function
export function getPackageInfo() {
  return {
    name: '@repo/data',
    version: '0.1.0',
    description: 'Data management and provider packages for Zopio framework'
  };
}
