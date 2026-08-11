<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { api, me, saveAuth } from '../auth';

const router = useRouter();
const notice = ref('');
const mode = ref('login');
const login = ref({ account: '', password: '' });
const signup = ref({
  phoneNumber: '',
  userName: '',
  email: '',
  password: '',
  coverImage: '',
  biography: '',
});

if (me.userId) {
  router.replace('/posts');
}

async function submit() {
  try {
    const endpoint = mode.value === 'login' ? 'login' : 'register';
    const payload = mode.value === 'login' ? login.value : signup.value;
    saveAuth(await api(`/api/auth/${endpoint}`, {
      method: 'POST',
      body: JSON.stringify(payload),
    }));
    router.push('/posts');
  } catch (error) {
    notice.value = error.message;
  }
}
</script>

<template>
  <section class="card auth">
    <h2>{{ mode === 'login' ? '登入' : '建立帳號' }}</h2>
    <nav>
      <button @click="mode = 'login'">登入</button>
      <button @click="mode = 'register'">註冊</button>
    </nav>

    <p v-if="notice" class="notice">{{ notice }}</p>

    <form @submit.prevent="submit">
      <template v-if="mode === 'register'">
        <input v-model="signup.userName" placeholder="名稱" required>
        <input v-model="signup.email" type="email" placeholder="Email" required>
        <input v-model="signup.phoneNumber" placeholder="手機號碼" required>
        <input v-model="signup.password" type="password" placeholder="密碼（至少 8 碼）" required>
        <input v-model="signup.coverImage" placeholder="封面圖片 URL（選填）">
        <textarea v-model="signup.biography" placeholder="自我介紹（選填）" />
      </template>
      <template v-else>
        <input v-model="login.account" placeholder="手機號碼或 Email" required>
        <input v-model="login.password" type="password" placeholder="密碼（至少 8 碼）" required>
      </template>
      <button>{{ mode === 'login' ? '登入' : '建立帳號' }}</button>
    </form>
  </section>
</template>
