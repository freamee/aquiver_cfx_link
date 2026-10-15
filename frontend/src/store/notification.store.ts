import { defineStore } from "pinia";
import { ref } from "vue";

interface INotification {
    id: number;
    message: string;
    icon: string;
    duration: number;
}

export const useNotificationStore = defineStore("notificationStore", () => {
    const notificationsState = ref<INotification[]>([]);

    function add(message: string, type: string, duration: number) {
        const id = 1;


        const notification: INotification = {
            id,
            message,
            duration,
            icon: "fas fa-check-circle"
        }

        notificationsState.value.push(notification);

        if (duration > 0) {
            setTimeout(() => remove(id), duration);
        }

        return notification;
    }

    function remove(id: number) {
        notificationsState.value = notificationsState.value.filter(i => i.id !== id);
    }

    function clear() {
        notificationsState.value = [];
    }

    return {
        notificationsState,
        add,
        remove,
        clear
    }
})