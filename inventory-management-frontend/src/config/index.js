/**
 * Application configuration
 */
export const config = {
  apiUrl: import.meta.env.VITE_API_URL || 'http://localhost:3000/api',
}

/**
 * Get the full API URL for a specific endpoint
 * @param {string} endpoint - The API endpoint
 * @returns {string} The full API URL
 */
export const getApiUrl = (endpoint) => {
  const baseUrl = config.apiUrl.endsWith('/')
    ? config.apiUrl.slice(0, -1)
    : config.apiUrl
  
  const cleanEndpoint = endpoint.startsWith('/')
    ? endpoint.slice(1)
    : endpoint
  
  return `${baseUrl}/${cleanEndpoint}`
}
