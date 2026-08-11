<script setup>
import { onMounted, ref, watch } from 'vue';
import { RouterLink, useRoute } from 'vue-router';
import { api, me } from '../auth';

const route = useRoute();
const profile = ref(null);
const posts = ref([]);
const notice = ref('');

async function load() {
  try {
    const userId = route.params.id;
    [profile.value, posts.value] = await Promise.all([
      api(`/api/users/${userId}`),
      api(`/api/users/${userId}/posts`),
    ]);
  } catch (error) {
    notice.value = error.message;
  }
}

watch(() => route.params.id, load);
onMounted(load);
</script>

<template>
  <p v-if="notice" class="notice">{{ notice }}</p>

  <template v-else-if="profile">
    <section class="card profile-header">
      <img v-if="profile.coverImage" :src="profile.coverImage" :alt="`${profile.userName} 的封面`">
      <div>
        <h2>{{ profile.userName }}</h2>
        <p>{{ profile.biography || '尚未填寫自我介紹。' }}</p>
        <small v-if="me.userId === profile.userId">這是你的個人頁面</small>
      </div>
    </section>

    <h3>{{ me.userId === profile.userId ? '我發表的貼文' : `${profile.userName} 發表的貼文` }}</h3>
    <article v-for="post in posts" :key="post.postId" class="card">
      <div class="meta">{{ new Date(post.createdAt).toLocaleString() }}</div>
      <p>{{ post.content }}</p>
      <img v-if="post.image" :src="post.image" alt="文章圖片">
      <div class="comments">
        <p v-for="comment in post.comments" :key="comment.commentId">
          <RouterLink :to="`/profile/${comment.userId}`">{{ comment.userName }}</RouterLink>
          ：{{ comment.content }}
        </p>
      </div>
    </article>
    <p v-if="posts.length === 0" class="card">尚未發表貼文。</p>
  </template>
</template>
