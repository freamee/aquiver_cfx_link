<template>
  <div>
    <NotificationComponent v-for="notify in notificationsState" :id="notify.id" :message="notify.message"
      :title="notify.title" :duration="notify.duration" :icon="notify.icon" />
  </div>
</template>

<script setup lang="ts">
import { storeToRefs } from 'pinia';
import NotificationComponent from './components/NotificationComponent.vue';
import { useNotificationStore } from './store/notification.store';

const notificationStore = useNotificationStore();
const { notificationsState } = storeToRefs(notificationStore);
</script>
