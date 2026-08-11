import { reactive } from 'vue';

export const me = reactive(JSON.parse(localStorage.user || 'null') || {});
export const token = () => localStorage.token || '';

export function saveAuth(value) {
  localStorage.token = value.token;
  localStorage.user = JSON.stringify(value.user);
  Object.assign(me, value.user);
}

export function logout() {
  localStorage.clear();
  Object.keys(me).forEach((key) => delete me[key]);
}

export async function api(url, options = {}) {
  const response = await fetch(url, {
    headers: {
      'Content-Type': 'application/json',
      ...(token() ? { Authorization: `Bearer ${token()}` } : {}),
    },
    ...options,
  });

  if (!response.ok) {
    const body = await response.json().catch(() => ({}));
    throw new Error(body.message || '操作失敗');
  }

  return response.status === 204 ? null : response.json();
}
