<script setup>
import { RouterLink, RouterView, useRouter } from 'vue-router';
import { logout, me } from './auth';

const router = useRouter();

function signout() {
  logout();
  router.push('/auth');
}
</script>

<template>
  <main>
    <header>
      <RouterLink class="brand" to="/posts">NewBook</RouterLink>
      <nav>
        <RouterLink to="/posts">貼文</RouterLink>
        <RouterLink v-if="me.userId" :to="`/profile/${me.userId}`">我的個人頁</RouterLink>
        <RouterLink v-if="!me.userId" to="/auth">登入 / 註冊</RouterLink>
        <span v-else>
          嗨，{{ me.userName }}
          <button @click="signout">登出</button>
        </span>
      </nav>
    </header>
    <RouterView />
  </main>
</template>
